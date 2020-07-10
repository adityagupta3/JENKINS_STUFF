import hudson.model.*;
import hudson.util.*;
import jenkins.model.*;
import hudson.FilePath.FileCallable;
def list = []
for (job in Jenkins.instance.getAllItems(AbstractItem.class) ) {

    if (job.fullName.startsWith('Sonata-Tests/MASTER/BART/'))
  	list.add(job.name)
 
  }
list.unique().each {
	println it
}