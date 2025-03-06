# install.packages("usethis")
library(usethis)

# git situation report
git_sitrep()

# ── Git global (user) 
# • Name: "Beatriz Milz"
# • Email: "42153618+beatrizmilz@users.noreply.github.com"
# • Global (user-level) gitignore file:
# • Vaccinated: FALSE
# ℹ See `usethis::git_vaccinate()` to learn more.
# • Default Git protocol: "https"
# • Default initial branch name: "main"
# 
# ── GitHub user 
# • Default GitHub host: "https://github.com"
# ! /Users/beatrizmilz/.Renviron defines the environment variable:
# • GITHUB_TOKEN
# ! This can prevent your PAT from being retrieved from the Git
#   credential store.
# ℹ If you are troubleshooting PAT problems, the root cause may be an
#   old, invalid PAT defined in /Users/beatrizmilz/.Renviron.
# ℹ For most use cases, it is better to NOT define the PAT in
#   .Renviron.
# ☐ Call usethis::edit_r_environ() to edit that file.
# ☐ Then call gitcreds::gitcreds_set() to put the PAT into the Git
#   credential store.
# • Personal access token for "https://github.com": <discovered>
# • GitHub user: "beatrizmilz"
# • Token scopes: "gist", "repo", "user", and "workflow"
# • Email(s): "42153618+beatrizmilz@users.noreply.github.com",
#   "milz.bea@gmail.com (primary)", and "contato@mangekyou.dev"
# ✖ Git user's email ("42153618+beatrizmilz@users.noreply.github.com")
#   doesn't appear to be registered with GitHub host.
# 
# ── Active usethis project: "/Users/beatrizmilz/Desktop/ipea-intermediario-2025" ──
# 
# ℹ Active project is not a Git repo.


# nos apresenta para o Git (o git instalado no computador)
use_git_config(
  user.name = "Beatriz Milz",
  user.email = "milz.bea@gmail.com"
)

git_sitrep()

# ── Git global (user) 
# • Name: "Beatriz Milz"
# • Email: "42153618+beatrizmilz@users.noreply.github.com"

# • Personal access token for "https://github.com": <unset>

# PAT -----

# função para abrir a página do github e criar um token
create_github_token()

# função para salvar o token criado
gitcreds::gitcreds_set()

# ghp_xxxxxxx

# ? Enter password or token: {COLOCAR O TOKEN!}
# -> Adding new credentials...
# -> Removing credentials from cache...
# -> Done.


# Reiniciar a sessão do R
# Menu superior -> session -> restart R

# > Restarting R session...

library(usethis)

# git situation report
git_sitrep()


# • Personal access token for "https://github.com": <discovered>

# Se tiver como <unset> é pq deu errado!


# transformar o rproj em um repositorio do git
library(usethis)

use_git()


# usethis::proj_get()


use_github()



# 
# ! [remote rejected] HEAD -> main (push declined due to email privacy restrictions)
# error: failed to push some refs to 'https://github.com/Itaquesb/testeDoGit'

# Itaquê, eu resolvi esse problema mudando as configurações no meu Github: Settings -> Emails  e desabilitei a opção 
# "Block command line pushes that expose my email"


