# grafana-all-in-one-release

## Features

- Bosh Release to Deploy a single Job/VM with the following:


	* Graphite
	* Postgresql
	* Grafana


- Will auto-deploy `statsd` listener bound to Graphite w/ Postgres backend DB
- Will auto-deploy `carbon`
- Will auto-deploy `graphite-web` ( defaults to 8080 )
- Will auto-deploy `grafana` ( defaults to 80 )
- Will auto-register the `graphite` instance as a source in `grafana`

**_NOT Intended for Production use. Primarily for POCs & Dojos_**.

## Requirements

- A functional BOSH instance on a supported IaaS/CPI 
	* (bosh-lite can be used for dev & test)
	* ([cloud config](https://bosh.io/docs/cloud-config.html) samples included for typical bosh deployment)
- The BOSH cli.  Installation documentation can be found [here](https://bosh.io/docs/bosh-cli.html)

## Installation / Deployment

1. Download the latest release from [here](https://github.com/pivotalservices/grafana-all-in-one-release/releases/latest).
<pre><code>wget "https://s3.amazonaws.com/bosh-grafana-all-in-one-release/releases/grafana-all-in-one-release-1.tgz"</code></pre>
2. Upload the release to your bosh target:
<pre><code>bosh upload release /tmp/grafana-all-in-one-release-#.tgz</code></pre>
3. Verify an `ubuntu-trusty` stemcell => 3262 is deployed:
<pre><code>$ bosh stemcells
Acting as user 'admin' on 'bosh'
+------------------------------------------+---------------+---------+----------------------------------------------------+
| Name                                     | OS            | Version | CID                                                |
+------------------------------------------+---------------+---------+----------------------------------------------------+
| bosh-azure-hyperv-ubuntu-trusty-go_agent | ubuntu-trusty | 3262.2* | bosh-stemcell-48e110cc-4897-440e-920c-cde986456f1a |
+------------------------------------------+---------------+---------+----------------------------------------------------+
</code></pre>
4. Generate a manifest for grafana-all-in-one-release.  Sample manifests can be found [here](https://github.com/pivotalservices/grafana-all-in-one-release/tree/master/sample_manifests).
	* There are `cloud-config` samples for multiple CPI's.   Cloud config manifests are deployed as such _after_ the samples have been updated for your IaaS:
	*  <pre><code>bosh update cloud-config sample_manifests/cloud-config-[IAAS]/cloud-config.yml
</code></pre>
5. Edit & Deploy the `sample_manifests/grafana-all-in-one.yml` manifest.  It can typically be deployed with no modification when using cloud config:
<pre><code>bosh deployment sample_manifests/grafana-all-in-one.yml
bosh -n deploy</code></pre>
	* The `sample_manifests/bosh-lite/graphite-bosh-lite.yml` manifest can be used with [bosh-lite](https://github.com/cloudfoundry/bosh-lite) for quick testing and devlopment
	* If using bosh-lite, you will need to add a custom route to access the resultant instance on your desktop.  For example, with default bosh-lite network settings on a mac, you would exec:
	<pre><code>sudo route -n add 10.244.0.0/19 192.168.50.4</code></pre>
6. After the deployment has succeeded, generate some sample data to `statsd`.  This can be done by:
	<pre><code>scripts/gen_stats.sh [IP ADDR OF GRAFANA JOB] [STATSD PORT/Defaults to 8125]</code></pre>
	* Next log into Grafana UI [default creds = `grafana`/`gr4f4n4`] ...
	* & then track the new "foo" metrics...
	![alt text](https://s3.amazonaws.com/bosh-grafana-all-in-one-release/images/simple-grafana.png "Some Foobitty Goodness!")

## Development

Documentation on the bosh release development process can be found [here](https://bosh.io/docs/create-release.html).

Please file any bugs/frs [here](https://github.com/pivotalservices/grafana-all-in-one-release/issues).

Helpful notes:

- If attempting to build the release from source `bosh sync blob`, you may experience the following error: <pre><code>simple_blobstore_client.rb:44:in `get_file': Could not fetch object, 404/ (Bosh::Blobstore::BlobstoreError)</code></pre>
	* This can typically be resolved by creating a `config/private.yml` manifest with appropriate s3 creds.  More data can be found [here](https://bosh.io/docs/s3-release-blobstore.html).

