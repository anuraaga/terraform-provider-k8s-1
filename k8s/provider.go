package k8s

import (
	"github.com/hashicorp/terraform/helper/schema"

        _ "k8s.io/client-go/plugin/pkg/client/auth/gcp"
)

func Provider() *schema.Provider {
	return &schema.Provider{
		Schema: map[string]*schema.Schema{
			"namespace": {
				Type:        schema.TypeString,
				Optional:    true,
				Default:     "default",
				Description: "Default namespace",
			},
		},

		ResourcesMap: BuildResourcesMap(),

		DataSourcesMap: BuildDataSourcesMap(),

		ConfigureFunc: providerConfigure,
	}
}

func providerConfigure(resourceData *schema.ResourceData) (interface{}, error) {
	k8sConfig := K8SConfig_Singleton()
	k8sConfig.Namespace = resourceData.Get("namespace").(string)
	return k8sConfig, nil
}
