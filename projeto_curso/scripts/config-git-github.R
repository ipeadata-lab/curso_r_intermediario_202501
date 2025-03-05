# Material da aula: https://ipeadata-lab.github.io/curso_r_intermediario_202501/git-github.html

# Instalar o pacote usethis, se necessário
# install.packages("usethis")

# Carregar o pacote usethis
library(usethis)

# Relatório da situação do Git
# Essa função ajuda a encontrar possíveis erros de configuração
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

# Configura o Git com nome e email do usuário
use_git_config(
  user.name = "Beatriz Milz",
  user.email = "milz.bea@gmail.com"
)

# Verifica novamente a situação do Git
git_sitrep()

# ── Git global (user)
# • Name: "Beatriz Milz"
# • Email: "42153618+beatrizmilz@users.noreply.github.com"

# • Personal access token for "https://github.com": <unset>

# PAT -----

# Abre a página do GitHub para criar um token de acesso pessoal (PAT)
create_github_token()

# O token tem um formato parecido com isso:
# ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
# ATENÇÃO: NUNCA SALVE O TOKEN NO SEU SCRIPT!!!!

# Salva o token criado
gitcreds::gitcreds_set()


# ? Enter password or token: {COLOCAR O TOKEN!}
# -> Adding new credentials...
# -> Removing credentials from cache...
# -> Done.

# Reiniciar a sessão do R
# Menu superior -> session -> restart R

# > Restarting R session...

library(usethis)

# Relatório da situação do Git
git_sitrep()

# • Personal access token for "https://github.com": <discovered>

# Se tiver como <unset> é porque deu errado!

# Transforma o projeto R em um repositório Git
library(usethis)
use_git()

# Cria um repositório no GitHub e conecta ao repositório local
use_github()
# Irá abrir uma página no seu navegador com a página do repositório criado