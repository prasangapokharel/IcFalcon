#!/usr/bin/env node

const { execSync } = require("child_process")
const fs = require("fs")
const path = require("path")
const os = require("os")

const REPO = "https://github.com/prasangapokharel/IcFalcon.git"
const args = process.argv.slice(2).filter((arg) => arg !== "--")
const projectName = args[0]

function fail(message) {
  process.stderr.write(`\n  error: ${message}\n\n`)
  process.exit(1)
}

function run(command, cwd, env = process.env) {
  execSync(command, { stdio: "inherit", cwd, shell: true, env })
}

function localBinPath() {
  return path.join(os.homedir(), ".local", "bin")
}

if (!projectName || projectName.startsWith("-")) {
  fail("usage: npm create icfalcon@latest <project-name>")
}

const target = path.resolve(process.cwd(), projectName)

if (fs.existsSync(target)) {
  fail(`"${projectName}" already exists`)
}

process.stdout.write(`\n  Creating IcFalcon app in ${projectName}...\n\n`)

try {
  run(`git clone --depth 1 ${REPO} "${target}"`)
} catch {
  fail("git clone failed — install git and try again")
}

const gitDir = path.join(target, ".git")
if (fs.existsSync(gitDir)) {
  fs.rmSync(gitDir, { recursive: true, force: true })
}

process.stdout.write("\n  Installing falcon CLI...\n\n")

try {
  run("bash ops/install.sh", target)
} catch {
  fail("./ops/install.sh failed")
}

const env = {
  ...process.env,
  PATH: `${localBinPath()}${path.delimiter}${process.env.PATH || ""}`,
}

process.stdout.write("\n  Running full setup (backend + frontend + dev server)...\n\n")

try {
  run("falcon s:init", target, env)
} catch {
  fail("falcon s:init failed — cd into your project and run: falcon s:init")
}
