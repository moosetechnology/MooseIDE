"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestMooseIDETagging,
	#superclass : #PackageManifest,
	#category : #'MooseIDE-Tagging-Manifest'
}

{ #category : #'code-critics' }
ManifestMooseIDETagging class >> ruleStringConcatenationRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#GradualTagsGenerationStrategy #generateTags: #false)) #'2022-08-09T14:19:39.666111+02:00') )
]
