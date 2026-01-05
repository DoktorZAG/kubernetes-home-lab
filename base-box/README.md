To build the Base-Box:

```
cd base-box
vagrant up
vagrant halt

vagrant package --base k8s-base-builder --output output/k8s-base.box
vagrant box add k8s-base ./output/k8s-base.box --force

vagrant destroy -f
```

After that remove the folder output