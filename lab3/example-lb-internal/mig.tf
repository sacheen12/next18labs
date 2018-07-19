/*
 * Copyright 2017 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

data "template_file" "group1-startup-script" {
  template = "${file("${format("%s/nginx_upstream.sh.tpl", path.module)}")}"

  vars {
    UPSTREAM = "${module.ilb-gce-ilb.ip_address}"
  }
}

data "template_file" "group2-startup-script" {
  template = "${file("${format("%s/gceme.sh.tpl", path.module)}")}"

  vars {
    PROXY_PATH = ""
  }
}

data "template_file" "group3-startup-script" {
  template = "${file("${format("%s/gceme.sh.tpl", path.module)}")}"

  vars {
    PROXY_PATH = ""
  }
}

module "ilb-mig1" {
  source            = "GoogleCloudPlatform/managed-instance-group/google"
  version           = "1.1.10"
  region            = "${var.gcp_region}"
  zone              = "${var.gcp_zone}"
  name              = "ilb-group1"
  size              = 2
  target_tags       = ["allow-group1"]
  target_pools      = ["${module.ilb-gce-lb-fr.target_pool}"]
  service_port      = 80
  service_port_name = "http"
  startup_script    = "${data.template_file.group1-startup-script.rendered}"
}

module "ilb-mig2" {
  source            = "GoogleCloudPlatform/managed-instance-group/google"
  version           = "1.1.10"
  region            = "${var.gcp_region}"
  zone              = "${var.gcp_zone2}"
  name              = "ilb-group2"
  size              = 2
  target_tags       = ["allow-group2"]
  service_port      = 80
  service_port_name = "http"
  startup_script    = "${data.template_file.group2-startup-script.rendered}"
}

module "ilb-mig3" {
  source            = "GoogleCloudPlatform/managed-instance-group/google"
  version           = "1.1.10"
  region            = "${var.gcp_region}"
  zone              = "${var.gcp_zone3}"
  name              = "ilb-group3"
  size              = 2
  target_tags       = ["allow-group3"]
  service_port      = 80
  service_port_name = "http"
  startup_script    = "${data.template_file.group3-startup-script.rendered}"
}
