build:
	docker build -t stan .

bash:
	docker run -it stan:latest /bin/bash
