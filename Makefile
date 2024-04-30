RunServer: 
	@cd server; cargo run
RunClient:
	@cd client/example; flutter run -d chrome --web-renderer canvaskit
GenClient: 
	@cd client; hoshmand gen project --config=config/converse.yaml --sdk=flutter

# this section of MakeFile pull the gitlab prject and ofter that add new changes to gitlab Project.
PushCode:
	@git add .;git commit -m "$(message)";git stash;git pull --rebase;git stash apply;git push
