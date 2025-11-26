"
I am a model for the SourceTextBrowser

I take care of getting the source code for an entity and ""formatting"" it (actually finding where to apply formats: the highlights)

I also keep the displayedEntity and the selectedEntity (in the source code) if any
"
Class {
	#name : 'MiSourceTextBrowserModel',
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
MiSourceTextBrowserModel class >> defaultConfiguration [

	^ MiSourceTextSettingsConfiguration new
		  shouldHighlightChildren: self defaultShouldHighlightChildren;
		  yourself
]

{ #category : 'as yet unclassified' }
MiSourceTextBrowserModel class >> defaultShouldHighlightChildren [

	^ true
]

{ #category : 'settings management' }
MiSourceTextBrowserModel >> currentConfiguration [

	^ MiSourceTextSettingsConfiguration new
		  shouldHighlightChildren: shouldHighlightChildren;
		  yourself
]

{ #category : 'settings management' }
MiSourceTextBrowserModel >> defaultConfiguration [

	^ self class defaultConfiguration
]

{ #category : 'accessing' }
MiSourceTextBrowserModel >> displayedEntity: anEntity [

	self selectedEntity: anEntity.

	renderer renderTextFor: anEntity
]

{ #category : 'accessing' }
MiSourceTextBrowserModel >> entities [

	^ entity ifNil: [ #(  ) ] ifNotNil: [ { entity } ]
]

{ #category : 'accessing' }
MiSourceTextBrowserModel >> entity: anEntity [
]

{ #category : 'actions' }
MiSourceTextBrowserModel >> event: aMouseEvent selectedEntity: anEntity [

	self selectedEntity: anEntity.

	aMouseEvent controlKeyPressed
		ifTrue: [ anEntity inspect ]
]

{ #category : 'testing' }
MiSourceTextBrowserModel >> hasSettings [

	^ true
]

{ #category : 'initialization' }
MiSourceTextBrowserModel >> initialize [
	super initialize.

	renderer := MiSourceTextRendererModel new.
	renderer resetHighlights
]

{ #category : 'initialization' }
MiSourceTextBrowserModel >> initializeSettings [

	shouldHighlightChildren := self class defaultShouldHighlightChildren
]

{ #category : 'accessing' }
MiSourceTextBrowserModel >> miSelectedItem [

	^self entities
]

{ #category : 'accessing' }
MiSourceTextBrowserModel >> rendererModel [

	^renderer 
]

{ #category : 'accessing' }
MiSourceTextBrowserModel >> selectedEntity [
	^entity
]

{ #category : 'accessing' }
MiSourceTextBrowserModel >> selectedEntity: anEntity [

	entity := anEntity.
	browser updateToolbar
]

{ #category : 'settings management' }
MiSourceTextBrowserModel >> settingsPresenterExtent [

	^ 375 @ 200
]

{ #category : 'accessing' }
MiSourceTextBrowserModel >> shouldHighlightChildren: aBoolean [

	renderer shouldHighlightChildren: aBoolean 
]

{ #category : 'settings management' }
MiSourceTextBrowserModel >> updateFromConfiguration: aConfiguration [

	self shouldHighlightChildren: aConfiguration shouldHighlightChildren.

	entity ifNil: [ ^ self ].

	renderer renderTextFor: entity
]
