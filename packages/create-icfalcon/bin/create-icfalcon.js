#!/usr/bin/env node

const { execSync, spawnSync } = require("child_process")
const fs = require("fs")
const path = require("path")
const os = require("os")

const REPO = "https://github.com/prasangapokharel/IcFalcon.git"
const args = process.argv.slice(2).filter((arg) => arg !== "--")
const projectName = args[0]

const frames = ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"]

function fail(message) {
  process.stderr.write(`\n  error: ${message}\n\n`)
  process.exit(1)
}

function hasCommand(name) {
  const result = spawnSync("bash", ["-lc", `command -v ${name}`], { encoding: "utf8" })
  return result.status === 0
}

function checkPrerequisites() {
  const missing = []
  if (!hasCommand("git")) missing.push("git")
  if (!hasCommand("dfx")) missing.push("dfx")
  if (!hasCommand("mops")) missing.push("mops")
  if (!hasCommand("node")) missing.push("node")
  if (!hasCommand("npm")) missing.push("npm")
  if (missing.length > 0) {
    fail(`missing prerequisites: ${missing.join(", ")}`)
  }
}

function run(command, cwd, env = process.env) {
  execSync(command, { stdio: "inherit", cwd, shell: true, env })
}

function runQuiet(command, cwd) {
  execSync(command, { stdio: "pipe", cwd, shell: true })
}

function runWithSpinner(label, action) {
  let index = 0
  const timer = setInterval(() => {
    process.stdout.write(`\r  ${frames[index % frames.length]} ${label}`)
    index += 1
  }, 80)

  try {
    action()
    clearInterval(timer)
    process.stdout.write(`\r  ✓ ${label}\n`)
  } catch (error) {
    clearInterval(timer)
    process.stdout.write(`\r  ✗ ${label}\n`)
    throw error
  }
}

function localBinPath() {
  return path.join(os.homedir(), ".local", "bin")
}

checkPrerequisites()

if (!projectName || projectName.startsWith("-")) {
  fail("usage: npm create icfalcon@latest <project-name>")
}

const target = path.resolve(process.cwd(), projectName)

if (fs.existsSync(target)) {
  fail(`"${projectName}" already exists`)
}

process.stdout.write(`\n  Creating ${projectName}...\n\n`)

try {
  runWithSpinner("Downloading IcFalcon", () => {
    runQuiet(`git clone --depth 1 --quiet ${REPO} "${target}"`)
  })
} catch {
  fail("download failed — check your internet connection and try again")
}

const gitDir = path.join(target, ".git")
if (fs.existsSync(gitDir)) {
  fs.rmSync(gitDir, { recursive: true, force: true })
}

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
