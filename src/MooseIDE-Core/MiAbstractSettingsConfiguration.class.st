Class {
	#name : 'MiAbstractSettingsConfiguration',
	#superclass : 'Object',
	#category : 'MooseIDE-Core-Settings',
	#package : 'MooseIDE-Core',
	#tag : 'Settings'
}

{ #category : 'instance creation' }
MiAbstractSettingsConfiguration class >> fromJson: aJsonString [

	^(NeoJSONReader on: aJsonString readStream)
		mapInstVarsFor: self ;
		nextAs: self
]

{ #category : 'converting' }
MiAbstractSettingsConfiguration >> asJSON [

	^String streamContents: [ :stream |
		(NeoJSONWriter on: stream)
			mapInstVarsFor: self class;
			nextPut: self ].
]

{ #category : 'ui' }
MiAbstractSettingsConfiguration >> settingsPresenters [

	^ OrderedCollection new
]
