"
I use the block text from MiCoUsageMapSettingsPresenter, stored in MiCoUsageMapSettings
If there is an error with the user input, I will return an empy list
"
Class {
	#name : #MiCoFromSettingsMethodAttributeTester,
	#superclass : #MiCoMethodAttributeCounter,
	#category : #'MooseIDE-CoUsageMap-Model'
}

{ #category : #public }
MiCoFromSettingsMethodAttributeTester >> allAttributesFor: aMiCoMethod [
	^ [ self settings childrenBlockCompiled value: aMiCoMethod mooseEntity ]
	onErrorDo: [ :ex | ex traceCr. #() ].
]
