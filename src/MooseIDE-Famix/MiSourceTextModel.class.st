"
I am a model for the SourceTextBrowser

I take care of getting the source code for an entity and ""formatting"" it (actually finding where to apply formats: the highlights)

I also keep the displayedEntity and the selectedEntity (in the source code) if any
"
Class {
	#name : 'MiSourceTextModel',
	#superclass : 'MiAbstractModel',
	#instVars : [
		'shouldHighlightChildren',
		'entity',
		'renderer'
	],
	#category : 'MooseIDE-Famix-SourceText',
	#package : 'MooseIDE-Famix',
	#tag : 'SourceText'
}

{ #category : 'accessing' }
MiSourceTextModel class >> defaultConfiguration [

	^ MiSourceTextSettingsConfiguration new
		  shouldHighlightChildren: self defaultShouldHighlightChildren;
		  yourself
]

{ #category : 'as yet unclassified' }
MiSourceTextModel class >> defaultShouldHighlightChildren [

	^ true
]

{ #category : 'settings management' }
MiSourceTextModel >> currentConfiguration [

	^ MiSourceTextSettingsConfiguration new
		  shouldHighlightChildren: shouldHighlightChildren;
		  yourself
]

{ #category : 'settings management' }
MiSourceTextModel >> defaultConfiguration [

	^ self class defaultConfiguration
]

{ #category : 'accessing' }
MiSourceTextModel >> displayedEntity: anEntity [

	self selectedEntity: anEntity.

	renderer renderTextFor: anEntity
]

{ #category : 'accessing' }
MiSourceTextModel >> entities [

	^ entity ifNil: [ #(  ) ] ifNotNil: [ { entity } ]
]

{ #category : 'accessing' }
MiSourceTextModel >> entity: anEntity [
]

{ #category : 'actions' }
MiSourceTextModel >> event: aMouseEvent selectedEntity: anEntity [

	self selectedEntity: anEntity.

	aMouseEvent controlKeyPressed
		ifTrue: [ anEntity inspect ]
]

{ #category : 'testing' }
MiSourceTextModel >> hasSettings [

	^ true
]

{ #category : 'initialization' }
MiSourceTextModel >> initialize [
	super initialize.

	renderer := MiSourceTextRendererModel new.
	renderer resetHighlights
]

{ #category : 'initialization' }
MiSourceTextModel >> initializeSettings [

	shouldHighlightChildren := self class defaultShouldHighlightChildren
]

{ #category : 'accessing' }
MiSourceTextModel >> miSelectedItem [

	^self entities
]

{ #category : 'accessing' }
MiSourceTextModel >> rendererModel [

	^renderer 
]

{ #category : 'accessing' }
MiSourceTextModel >> selectedEntity [
	^entity
]

{ #category : 'accessing' }
MiSourceTextModel >> selectedEntity: anEntity [

	entity := anEntity.
	browser updateToolbar
]

{ #category : 'settings management' }
MiSourceTextModel >> settingsPresenterExtent [

	^ 375 @ 200
]

{ #category : 'accessing' }
MiSourceTextModel >> shouldHighlightChildren: aBoolean [

	renderer shouldHighlightChildren: aBoolean 
]

{ #category : 'settings management' }
MiSourceTextModel >> updateFromConfiguration: aConfiguration [

	self shouldHighlightChildren: aConfiguration shouldHighlightChildren.

	entity ifNil: [ ^ self ].

	renderer renderTextFor: entity
]
