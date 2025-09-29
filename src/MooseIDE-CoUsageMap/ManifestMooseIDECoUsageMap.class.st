"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestMooseIDECoUsageMap,
	#superclass : #PackageManifest,
	#category : #'MooseIDE-CoUsageMap-Manifest'
}

{ #category : #'code-critics' }
ManifestMooseIDECoUsageMap class >> ruleCollectionProtocolRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#MiCoUsageMapBuilder #updateInnerBoxSize #false)) #'2023-04-10T19:35:58.266523+02:00') )
]
