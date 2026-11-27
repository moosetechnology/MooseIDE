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

{ #category : 'accessing' }
MiAbstractSettingsConfiguration >> associationTypesMode [
	"Answer #all, #none or #custom. nil means that the choice is not stored"

	^ nil
]

{ #category : 'accessing' }
MiAbstractSettingsConfiguration >> associationTypesMode: aSymbol [
	"Override to store the choice"
]

{ #category : 'ui' }
MiAbstractSettingsConfiguration >> settingsPresenters [

	^ OrderedCollection new
]

{ #category : 'accessing' }
MiAbstractSettingsConfiguration >> tagsMode [
	"Answer #all, #none or #custom. nil means that the choice is not stored"

	^ nil
]

{ #category : 'accessing' }
MiAbstractSettingsConfiguration >> tagsMode: aSymbol [
	"Override to store the choice"
]
