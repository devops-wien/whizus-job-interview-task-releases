# The Story

## WhizWare Corp

Alice has been working for many years at WhizWare and remembers these days of mainframes and then the transition to the more modern stack. After the usual monolithic design, somewhen, microservices became the new now. As the management require to catch up with the modern trends, she has been asked to move current monoliths to Kubernetes. Some of them are still monolithic and are deployed in a **multi-instance[^1] way**. Some teams are already ahead and splitted their monoliths into several microservices which could be already deployed. 

> *One of the most important topics where noone has any clue yet is how to do the promotion of different versions then[^2]? Usually the servers were just there and deploying a new version of the app was quite simple by just clicking the right button in the pipeline. Ops guys managed the servers including the other infrastructure, now there is this additional YAML-engineering stuff one need to care about.* - Alice thought.

> *Good that Bob is back from vacation!* 
 
She suggests to design some drafts for how the new process could look like with release promotion and versioning.

---

*Alice*: Hey Bob! Hope you enjoyed your vacation and relaxed! Maybe you noticed that we've got this new microservice movement thingy. That'll become funny I guess. Could you support me with the PoC?

*Bob:* Thx, Alice! Yeah, I recovered. But as always vacation is just too short. What exactly you would like to start with?

*Alice*: Well, first thing to consider is the movement of the monoliths I think. Some guys are already using Helm Charts so the best would be to start with that as the deployment configuration. We can of course look into kustomize if it would be simpler.

*Bob:* Is there some base chart available or how?

*Alice*: That's a good question. I guess it's up to us how we design it. What we should do is to definitely split the application repo from the YAML stuff. I guess we don't even have any contribution rights to many of the app repos so that would be the only way anyway.

*Bob:* Sure, I guess it's even suggested by this great [GitOps book](https://www.manning.com/books/gitops-and-kubernetes), if I remember correctly[^3]. 

*Alice:* Definitely! So following is really important:
  - we have different app version, that's out of our control, we don't require to know how they create them (using GitFlow, Trunk Based, whatever)
  - they have the legacy pipeline which uploads the version to different stage, PROD is only possible after multiple approvement
  - we MUST change as less as possible of the current CI (i.e. building the app, testing, a.s.o.)
  - we need to connect the resulting artifact[^4] with the stage in the corresponding Kubernetes environment

*Bob:* Ok, got it. So as soon as they create a new version of the app our part mainly starts. What about the helm chart? How do we handle versions there in case we need to upgrade some `apiVersion` or similar?

*Alice:* That's a good point. Well, the Helm Chart will be versioned as well, I don't know if we put the app version being deployed to a stage in the chart repo and then deploy the chart or in some config repo. I saw in [ArgoCD](https://argo-cd.readthedocs.io/en/stable/) there is this new [ApplicationSet](https://argocd-applicationset.readthedocs.io/en/stable/) feature which will greatly help us with this deployments of the same app for different customers. There some examples with [config files](https://argocd-applicationset.readthedocs.io/en/stable/Generators-Git/#git-generator-files) but I've never used that.

*Bob:* I got it so far. So app versions will be available, chart versions will be released by us. I guess we'll just put it together in these config files. But I still strugle with the imagination of the promotion to the stages. I guess for the microservice setup it will be similar but we'll not have multiple "PROD" stage like it is with the multi-instance thing. Another point will be these `values.yaml` mess, I don't have any idea now how to manage that without headaches.

*Alice:* Exactly! Let's draw our brainstorming so we don't forget it. Next days there is this great meetup where Tom from "GitOpsify" will talk about exactly this things. These guys can help us identify any possible issues in our approach or I guess maybe suggest some better solution. Let's get there, especially for the delicious pizza!

---

From the book[^3]

> Using a separate Git repository to hold your Kubernetes manifests (aka config), keeping the config separate from your application source code, is highly recommended
for the following reasons:
> - It provides a clean separation of application code and application config. There
will be times when you wish to modify the manifests without triggering an entire
CI build. For example, you likely do not want to trigger a build if you simply
want to bump the number of replicas in a Deployment spec.

---

[^1]: *The same monolithic application is deployed for each customer with the customer being isolated from the others*

[^2]: *App version, manifests version, config versions, a.s.o. are meant here*

[^3]: *Chapter 3, 3.2 Git strategies*

[^4]: *just a docker image*