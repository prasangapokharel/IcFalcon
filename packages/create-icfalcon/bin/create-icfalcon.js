#!/usr/bin/env node

const { execSync, spawnSync } = require("child_process")
const fs = require("fs")
const path = require("path")
const os = require("os")

const REPO = "https://github.com/prasangapokharel/IcFalcon.git"
const args = process.argv.slice(2).filter((arg) => arg !== "--")
const projectName = args[0]

const frames = ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"]
const isTTY = process.stdout.isTTY
const cyan = isTTY ? "\x1b[36m" : ""
const dim = isTTY ? "\x1b[2m" : ""
const reset = isTTY ? "\x1b[0m" : ""

function printBanner() {
  const bannerPath = path.join(__dirname, "..", "assets", "prefixAscii.txt")
  if (!fs.existsSync(bannerPath)) {
    return
  }

  const lines = fs.readFileSync(bannerPath, "utf8").split("\n")
  for (const line of lines) {
    if (!line.trim()) {
      continue
    }
    process.stdout.write(`${cyan}${line}${reset}\n`)
  }
  process.stdout.write(`${dim}Internet Computer app framework${reset}\n`)
}

function fail(message) {
  stopSpinner()
  process.stderr.write(`\n  error: ${message}\n\n`)
  process.exit(1)
}

function hasCommand(name) {
  const result = spawnSync("bash", ["-lc", `command -v ${name}`], { encoding: "utf8" })
  return result.status === 0
}

let spinnerTimer = null
let spinnerIndex = 0
let spinnerLabel = ""

function startSpinner(label) {
  stopSpinner()
  spinnerLabel = label
  spinnerIndex = 0
  process.stdout.write(`  ${frames[0]} ${label}`)
  spinnerTimer = setInterval(() => {
    spinnerIndex += 1
    const frame = frames[spinnerIndex % frames.length]
    process.stdout.write(`\r  ${frame} ${spinnerLabel}`)
  }, 80)
}

function stopSpinner(success = true, label = spinnerLabel) {
  if (!spinnerTimer) {
    return
  }
  clearInterval(spinnerTimer)
  spinnerTimer = null
  const mark = success ? "✓" : "✗"
  const stream = success ? process.stdout : process.stderr
  stream.write(`\r  ${mark} ${label}${" ".repeat(8)}\n`)
}

function runWithSpinner(label, action) {
  startSpinner(label)
  try {
    action()
    stopSpinner(true, label)
  } catch (error) {
    stopSpinner(false, label)
    throw error
  }
}

function checkPrerequisites() {
  const required = [
    { name: "git", hint: "https://git-scm.com/downloads" },
    { name: "node", hint: "https://nodejs.org" },
    { name: "npm", hint: "included with Node.js" },
    { name: "dfx", hint: "sh -ci \"$(curl -fsSL https://internetcomputer.org/install.sh)\"" },
    { name: "mops", hint: "npm install -g ic-mops" },
  ]

  const missing = required.filter((item) => !hasCommand(item.name))

  if (missing.length === 0) {
    return
  }

  stopSpinner(false, "Checking prerequisites")
  process.stderr.write("\n  error: missing prerequisites\n\n")
  for (const item of missing) {
    process.stderr.write(`    ${item.name}\n      ${item.hint}\n\n`)
  }
  process.stderr.write("  Install the tools above, then run:\n")
  process.stderr.write("    npm create icfalcon@latest <project-name>\n\n")
  process.exit(1)
}

function run(command, cwd, env = process.env) {
  execSync(command, { stdio: "inherit", cwd, shell: true, env })
}

function runQuiet(command, cwd) {
  execSync(command, { stdio: "pipe", cwd, shell: true })
}

function localBinPath() {
  return path.join(os.homedir(), ".local", "bin")
}

printBanner()

if (!projectName || projectName.startsWith("-")) {
  fail("usage: npm create icfalcon@latest <project-name>")
}

const target = path.resolve(process.cwd(), projectName)

if (fs.existsSync(target)) {
  fail(`"${projectName}" already exists`)
}

process.stdout.write(`\n  ${dim}Creating${reset} ${projectName}\n\n`)

runWithSpinner("Checking prerequisites", checkPrerequisites)

try {
  runWithSpinner("Downloading template", () => {
    runQuiet(`git clone --depth 1 --quiet ${REPO} "${target}"`)
  })
} catch {
  fail("download failed — check your internet connection and try again")
}

runWithSpinner("Preparing project", () => {
  const gitDir = path.join(target, ".git")
  if (fs.existsSync(gitDir)) {
    fs.rmSync(gitDir, { recursive: true, force: true })
  }
})

try {
  runWithSpinner("Installing falcon CLI", () => {
    runQuiet("bash ops/install.sh", target)
  })
} catch {
  fail("./ops/install.sh failed")
}

const env = {
  ...process.env,
  PATH: `${localBinPath()}${path.delimiter}${process.env.PATH || ""}`,
  FALCON_PROGRESS: "1",
}

process.stdout.write("\n")

try {
  run("bash ops/scripts/setup-init.sh", target, env)
} catch {
  fail(`setup failed — cd ${projectName} and run: falcon s:init`)
}
