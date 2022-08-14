# Declare which targets(task) don't need to generate target-file.
.PHONY: all help clean get upgrade clean_get lint format run_unit_test run_dev run_prof run_prod run_web_dev run_web_prof run_web_prod distribute_testflight build_runner commit

##

all: lint format run_dev ## Run default tasks. Run in `make` and has no target.

help: ## Know all commands.
	@IFS=$$'\n' ; \
	help_lines=(`fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//'`); \
	for help_line in $${help_lines[@]}; do \
			IFS=$$'#' ; \
			help_split=($$help_line) ; \
      help_command=`echo $${help_split[0]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
			help_info=`echo $${help_split[2]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
			printf "%-30s    %s\n" $$help_command $$help_info ; \
	done

##
## --- Basic ---

clean: ## Clean the environment.

	@echo "⚡︎Cleaning the project..."

	@rm -rf pubspec.lock
	@flutter clean

	@echo "⚡︎Project clean successfully!"

get: ## Get pub packages.
	@echo "⚡︎Getting flutter pub..."

	@flutter pub get

	@echo "⚡︎Flutter pub get successfully!"

upgrade: ## Upgrade pub packages.
	@echo "⚡︎Upgrading flutter pub..."

	@flutter pub upgrade

	@echo "⚡︎Flutter pub upgrade successfully!"


clean_get: clean get ## Get packages after cleaning the environment.
	@echo "⚡︎Flutter pub clean and get successfully!"

lint: ## Analyze the code and find issues.
	@echo "⚡︎Analyzing code..."

	@dart analyze . || (echo "Error in analyzing, some code need to optimize."; exit 99)

	@echo "⚡︎Code is perfect."

format: ## Format the code.
	@echo "⚡︎Formatting code..."

	@dart format .

	@echo "⚡︎Code format successfully!"

##
## --- Run ---

run_unit_test: ## Run unit tests.
	@echo "⚡︎Start running unit tests."

	@flutter test || (echo "Error in testing."; exit 99)

	@echo "⚡︎All unit tests are good!"

run_dev: ## Run app in dev.
	@flutter run || (echo "Error in running dev."; exit 99)
# @flutter run --flavor dev || (echo "Error in running dev."; exit 99)

run_prof: ## Run app in profile.
	@flutter run --profile || (echo "Error in running profile."; exit 99)

run_prod: ## Run app in release.
	@flutter run --release || (echo "Error in running release."; exit 99)

run_web_dev: ## Run web in dev.
	@flutter run -d chrome --dart-define=ENVIRONMENT=dev

run_web_prof: ## Run web in profile.
	@flutter run --profile -d chrome --dart-define=ENVIRONMENT=profile

run_web_prod: ## Run web in release.
	@flutter run --release -d chrome --dart-define=ENVIRONMENT=release

##
## --- Distribute ---

distribute_testflight: lint format ## Distribute to TestFlight.
	@echo "⚡︎Distributing app to TestFlight..."

	@echo "TestFlight"

	@echo "⚡︎Distribute app successfully!"

##
## --- Build ---

build_runner: ## Run build_runner and generate files automatically.
	@echo "⚡︎Running build_runner..."

	@flutter pub run build_runner build --delete-conflicting-outputs

	@echo "⚡︎Run build_runner and generate files successfully!"

##
## --- Git ---

commit: format lint run_unit_test ## Commit to Git.
	@echo "⚡︎Committing new updates..."

	@git add .
	@git commit

	@echo "⚡︎Git commit successfully!"

##