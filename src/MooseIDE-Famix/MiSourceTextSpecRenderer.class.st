"
A renderer of highlighted source text using `SpTextPresenter`.
It can `MiSourceTextSpecRenderer >> #renderTextFor: anEntity` by applying the highlights of its `#model`
Highlighting relies on Famix: to get the SourceLanguage keywords and to get the position of Famix entities.
Some parts of the text are clickable and will trigger `MiSourceTextSpecRenderer >> #activateTransmissionWithValue:` (because the renderer uses `SpTActivable`)

A renderer has a `MiSourceTextBrowserModel` and a parent browser which can be a `MiSourceTextBrowser` or an Inspector.

"
Class {
	#name : 'MiSourceTextSpecRenderer',
	#superclass : 'SpTextPresenter',
	#traits : 'SpTActivable',
	#classTraits : 'SpTActivable classTrait',
	#instVars : [
		'#formatedText',
		'#rendererModel',
		'#selectedItem => ObservableSlot'
	],
	#category : 'MooseIDE-Famix-SourceText',
	#package : 'MooseIDE-Famix',
	#tag : 'SourceText'
}

{ #category : 'formatting' }
MiSourceTextSpecRenderer >> activateTransmissionWithValue: aValue [
	"2 actions for each possible use:
	 - inside a MiSourceTextBrowser, #selectedItem is an ObservableSlot
	   that will trigger transmission to the owner
	 - inside an Inspector, there is an #activationAction to do the same thing"

	selectedItem := aValue.
	activationAction ifNotNil: [ :action | action cull: (SpActivatedSelection newValue: aValue)]
]

{ #category : 'formatting' }
MiSourceTextSpecRenderer >> applyCommentHighlight: aHighlight [
	"remove all other attributes on comments and set color attribute to grey"

	self clearFormatingFrom: aHighlight from to: aHighlight to.

	self applyHighlight: aHighlight markers: self commentMarkers
]

{ #category : 'formatting' }
MiSourceTextSpecRenderer >> applyErrorHighlight: aHighlight [

	self applyHighlight: aHighlight markers: self errorMarkers
]

{ #category : 'formatting' }
MiSourceTextSpecRenderer >> applyHighlight: aHighlight markers: markers [

	markers do: [ :marker |
		formatedText
			addAttribute: marker
			from: aHighlight from
			to: aHighlight to
	]
]

{ #category : 'formatting' }
MiSourceTextSpecRenderer >> applyIdentifierHighlight: aHighlight [
	"Clicking on identifiers initiate transmission to the owner presenter"

	self applyHighlight: aHighlight markers: self identifierMarkers.

	formatedText 
		addAttribute:
			(TextDoIt new actOnClickBlock: [ :ignored :event |
				self activateTransmissionWithValue: aHighlight highlightedEntity ])
		from: aHighlight from
		to: aHighlight to
]

{ #category : 'formatting' }
MiSourceTextSpecRenderer >> applyKeywordHighlight: aHighlight [

	self applyHighlight: aHighlight markers: self keywordMarkers
]

{ #category : 'formatting' }
MiSourceTextSpecRenderer >> applyTagHighlight: aHighlight [

	self applyHighlight: aHighlight markers: (self tagMarkers: aHighlight color)
]

{ #category : 'accessing' }
MiSourceTextSpecRenderer >> browser [
	^self owner
]

{ #category : 'formatting' }
MiSourceTextSpecRenderer >> clearFormatingFrom: start to: stop [

	formatedText := formatedText copyReplaceFrom: start to: stop with: (formatedText copyFrom: start to: stop) asString
]

{ #category : 'accessing - markers' }
MiSourceTextSpecRenderer >> commentMarkers [

	^{TextColor gray}
]

{ #category : 'initialization' }
MiSourceTextSpecRenderer >> connectPresenters [
	"When receiver is created as part of an Inspector, #owner is nil at this point
	   so we cannot `register` the transmission now
	   (note: in this case, the registering is done later automatically by the Inspector)
	 This is used when the receiver is part of a MiSourceTextBrowser"

	self owner ifNotNil: [ self transmitTo: self owner ]
]

{ #category : 'ports' }
MiSourceTextSpecRenderer >> defaultOutputPort [ 

	^SpPropertyChangedPort
		newPresenter: self
		property: #selectedItem
]

{ #category : 'accessing - markers' }
MiSourceTextSpecRenderer >> errorMarkers [

	^{TextColor red}
]

{ #category : 'actions' }
MiSourceTextSpecRenderer >> event: anEvent selectedEntity: anEntity [

	rendererModel event: anEvent selectedEntity: anEntity.
	self inform: 'Selected entity: ' , anEntity asString
]

{ #category : 'accessing' }
MiSourceTextSpecRenderer >> formatedText [
	^formatedText 
]

{ #category : 'accessing - markers' }
MiSourceTextSpecRenderer >> identifierMarkers [

	self flag: 'unfortunately TextEmphasis dominates: TextColor'.

	^{ TextColor color: (Color fromHexString: '237ea6') . TextEmphasis underlined }
]

{ #category : 'initialization' }
MiSourceTextSpecRenderer >> initialize [
	super initialize.
	self beNotEditable.

]

{ #category : 'accessing - markers' }
MiSourceTextSpecRenderer >> keywordMarkers [

	^{TextColor color: (Color fromHexString: '073fff')}
]

{ #category : 'rendering' }
MiSourceTextSpecRenderer >> renderText [

	formatedText := rendererModel displayedText asText.

	rendererModel highlights do: [ :hlght |
			hlght hasInterval
				ifTrue: [ hlght applyTo: self ] ].

	self clearContent.
	self text: formatedText
]

{ #category : 'rendering' }
MiSourceTextSpecRenderer >> renderTextFor: anEntity [

	rendererModel renderTextFor: anEntity
]

{ #category : 'accessing' }
MiSourceTextSpecRenderer >> rendererModel [

	^ rendererModel
]

{ #category : 'accessing' }
MiSourceTextSpecRenderer >> rendererModel: anObject [

	rendererModel := anObject.
	anObject renderer: self
]

{ #category : 'initialization' }
MiSourceTextSpecRenderer >> setModelBeforeInitialization: aModel [

	self rendererModel: aModel
]

{ #category : 'accessing - markers' }
MiSourceTextSpecRenderer >> tagMarkers: aColor [

	^{TextColor color: aColor}
]
