"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestMooseIDEButterflyMap,
	#superclass : #PackageManifest,
	#category : #'MooseIDE-ButterflyMap-Manifest'
}

{ #category : #'code-critics' }
ManifestMooseIDEButterflyMap class >> ruleCollectionProtocolRuleV1FalsePositive [
	^ #(#(#(#RGPackageDefinition #(#'MooseIDE-ButterflyMap')) #'2022-04-27T11:02:28.231326+02:00') )
]

{ #category : #'code-critics' }
ManifestMooseIDEButterflyMap class >> ruleLongMethodsRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#MiButterflyMapBuilder #buildShapes #false)) #'2022-04-26T15:59:07.396017+02:00') )
]
