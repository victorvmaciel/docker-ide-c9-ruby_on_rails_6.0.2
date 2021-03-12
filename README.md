# IDE Ruby on Rails Cloud9

Uma imagem do Ubuntu 18.04 64 bits em Docker contendo um ambiente de desenvolvimento em Ruby on Rails pronto para utilizar.

Não é necessário a instalação de dependências pois já vem todo configurado no padrão Rails
A imagem possui uma IDE open-source da Amazon chamada Cloud9 e deve ser iniciada utilizando um docker-compose padrão.


# Conteúdo da imagem IDE Ruby on Rails Cloud9
  
  - Ruby 2.7.1
  - Rails 6
  - Yarn 1.12
  - Bundler 2.1
  - instantclient-basic-linux.x64-12.2.0.1.0
  - instantclient-sdk-linux.x64-12.2.0.1.0
  - instantclient-sqlplus-linux.x64-12.2.0.1.0
  - psql (PostgreSQL) 11.7
  - rvm 1.29


----

# Pré-requisitos 

Linux Ubuntu 16.04 64bits
 

# Instalar o docker de acordo com sua distribuição do linux sendo a versão Docker desejada

      https://docs.docker.com/install/linux/docker-ce/ubuntu/

# Instalar o docker-compose

      https://docs.docker.com/compose/install/
      
Executar o comando abaixo para subir o container:

      $CURRENT_UID=$(id -u) CURRENT_GID=$(id -g) docker-compose up -d
O container ficará disponível em seu navegador na porta 8000:
http://localhost:8000/

![idec9-home](https://user-images.githubusercontent.com/22057957/110880424-5f0c3f00-82bd-11eb-8ee9-533f4fb6ded1.jpeg)

Para utilizar o terminal da do cloud9 clicar no botão "+" e selecionar New Terminal, ou simplesmente digitar o atalho "Alt + T" do seu teclado.
Clonar o projeto que deseja e especificar a branch de desenvolvimento utilizando o git clone, entrar na pasta do projeto e fazer git checkout.
A branch vai se encontrar na pasta local da sua máquina, ou seja, foi criado um elo entre o cloud9 e seu computador. O local na sua máquina que ficará salvo o seu código é chamado volume, e pode ser localizado no caminho abaixo (na sua máquina fora da IDE):

/home/${USER}/

aso queira parar o container, voltar para o terminal da sua máquina e entrar novamente na pasta do projeto onde está o arquivo docker-compose e usar o comando abaixo:
docker-compose down
Seu usuário irar logar com "abc" no console do cloud9;
No container foi criado um usuário local chamado abc que possui as mesmas permissões do seu usuário (id $user);
Lembre-se, por ser um container o mesmo será destruido após pará-lo, porém ele faz um compartilhamento de arquivos entre sua maquina local e container docker localizado em:

/home/${USER}/:code

Este compartilhamento é chamado volume, onde ficará armazenado a branch que está trabalhando.
Para subir a aplicação basta executar os comandos baixo para fazer o build:
Entrar na pasta do projeto nomeDoProjeto/src/aplicacao/ e executar:
bundle install
Caso encontre o erro abaixo ao instalar o bundle:
/usr/local/rvm/rubies/ruby-2.7.1/lib/ruby/2.7.0/rubygems.rb:275:in `find_spec_for_exe': Could not find 'bundler' (1.17.1) required by your /code/rails-appref/src/aplicacao/Gemfile.lock. (Gem::GemNotFoundException)
Executar o comando:
bundle update --bundler

E em seguida
 yarn install

Por fim, para subir a aplicação que segue o padrão rails appref, entrar na pasta /code/NOMEDOPROJETO/src/aplicacao (via terminal) e executar o comando rails server:
rails s -b 0.0.0.0
Para visualizar a aplicação e testar, acessar o seguinte endereço no navegador:

http://localhost:3000

Caso ocorra erro de permissão ao utilizar comandos docker sem sudo, favor reiniciar a máquina pois de acordo com a documentação é necessário; Erro que geralmente ocorre:


Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get http://%2Fvar%2Frun%2Fdocker.sock/v1.40/containers/json: dial unix /var/run/docker.sock: connect: permission denied

Outro erro que pode ocorrer ao realizar bundle install, é um erro de permissão na pasta do rvm:

        Gem::FilePermissionError: You don't have write permissions for the /usr/local/rvm/gems/ruby-2.7.1/wrappers directory.
        An error occurred while installing minitest (5.14.1), and Bundler cannot continue.

Para contornar o erro, pode executar o chmod abaixo sem problemas, pois é um container:
        
        $sudo chmod -R 777 /usr/local/rvm
        
Se precisar alterar alterar ou adicionar a porta da sua aplicação, é necessário parar o container na sua máquina com o comando:
        
        $docker-compose down
        
Editar o campo "ports" do arquivo docker-compose.yaml contindo no projeto escolhido:

Em seguida, subir o container com o comando de inicialização:
CURRENT_UID=$(id -u) CURRENT_GID=$(id -g) docker-compose up -d
