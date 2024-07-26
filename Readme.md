# Portable development environment

This creates a development environment that includes everything you need to
connect to a remote GKE cluster, develop, and deploy.

Every developer already has their favorite editor installed, but you might not have
the tools installed to work with our system, so this development environment
is here to provide those pieces that might be missing.


By the way, this development environment is completely optional. If you prefer
to install all of these tools to your desktop, you can do that as well.


## Get started

To get started, just run the enter script

```
./enter.sh
```

This will build a docker image and then enter the container.
The first time you run this, it will download some large files, so it will take a while.
Go grab some lunch. That gcloud tarball is real monster.

Don't worry, After the first time, it will be much faster.

If you read the enter script, you'll notice that it mounts the container home directory
into the `user-homedir` folder. This folder allows you to copy files to and from the environment.


This script gets you about 90% there. But there are a few more steps you'll have to do yourself.
Follow the steps below to log in and configure access with kubectl



## Authenticating

You need to authenticate with google cloud to access the cluster. To do this, run the following command

```
$  gcloud auth login
```

This will give you a URL you can use to log into your google account. Follow the prompts to authenticate.


if successful, you should be able to view projects you have access to. If you see something that looks like this,
then you're on the right track

NOTE: as you work on the project, your login may expire. If you find yourself unable to access the cluster after a day or so,
you probably need to run `gcloud auth login` again to refresh your login


```
$ gcloud projects list
PROJECT_ID     NAME      PROJECT_NUMBER
newproject-bf60  newproject  111111111111
```


(optional) Set this project as the default. This will save you from having to specify the project every time you run a command.

``` 
gcloud config set project newproject-bf60

```

## Connecting to the cluster

List the cluster so we know the name of it.

```
gcloud container clusters list
NAME          LOCATION     MASTER_VERSION      MASTER_IP      MACHINE_TYPE  NODE_VERSION        NUM_NODES  STATUS
newproject-gke  us-central1  1.29.6-gke.1038001  34.30.227.205  e2-small      1.29.6-gke.1038001             RUNNING
```

Finally, you are ready to configure your kubeconfig

```
$ gcloud container clusters get-credentials newproject-gke --location us-central1
Fetching cluster endpoint and auth data.
kubeconfig entry generated for newproject-gke.
```

You've done it! If you have followed along this far, you should have access to this cluster.
Check it out!

```
$ kubectl get namespaces
NAME                       STATUS   AGE
cluster-gateway            Active   12h
default                    Active   49d
gke-gmp-system             Active   49d
gke-managed-cim            Active   49d
gke-managed-filestorecsi   Active   49d
gke-managed-system         Active   49d
gmp-public                 Active   49d
kube-node-lease            Active   49d
kube-public                Active   49d
kube-system                Active   49d
sealed-secrets             Active   36d
```


## What's next?

You're now ready to start developing and deploying!

Remember, you can use the mounted home directory in the `user-homedir` folder to copy files to and from the container.
I recommend cloning your project into this folder so you can easily access it from the container.
