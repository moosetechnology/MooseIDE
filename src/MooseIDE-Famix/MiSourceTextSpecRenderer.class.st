"
A renderer of highlighted source text using Spec SpTextPresenter.
Ideally it would be subclass of a MiSourceTextAbstractRenderer, but it also need to inherit from SpTextPresenter

A renderer has a MiSourceTextBrowserModel and a browser.
It can #renderText by applying the highlights of its #model
"
Class {
	#name : 'MiSourceTextSpecRenderer',
	#superclass : 'SpTextPresenter',
	#traits : 'SpTActivable',
	#classTraits : 'SpTActivable classTrait',
	#instVars : [
		'#formatedText',
		'#sourceAnchorAdapter',
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

	self applyHighlight: aHighlight markers: (self tagMarkers: aHighlight tag)
]

{ #category : 'accessing' }
MiSourceTextSpecRenderer >> browser [
	^self owner
]

{ #category : 'formatting' }
MiSourceTextSpecRenderer >> clearFormating [

	formatedText := formatedText asString asText
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

	sourceAnchorAdapter := MiSourceTextNullAdapter new.

]

{ #category : 'accessing - markers' }
MiSourceTextSpecRenderer >> keywordMarkers [

	^{TextColor color: (Color fromHexString: '073fff')}
]

{ #category : 'rendering' }
MiSourceTextSpecRenderer >> reRenderText [
	"Apply highlights if needed
	 Re-display (requires to clear the text first)"

	self clearFormating.

	rendererModel highlights do: [ :hlght |
			hlght adaptSourceAnchorWith: self sourceAnchorAdapter.
			hlght hasInterval ifTrue: [ hlght applyTo: self ] ].

	self clearContent.
	self text: formatedText
]

{ #category : 'rendering' }
MiSourceTextSpecRenderer >> renderTextFor: anEntity [
	
	formatedText := rendererModel displayedText asText.

	[
		sourceAnchorAdapter := MiAbstractSourceTextAnchorAdapter adapterFor: anEntity.
		sourceAnchorAdapter initializeDisplayedText: formatedText andEntity: anEntity.

		self reRenderText
	]
	on: Error
	do: [ :err | "nothing but at least  display unadorned text" ]

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

{ #category : 'accessing' }
MiSourceTextSpecRenderer >> sourceAnchorAdapter [

	^sourceAnchorAdapter
]

{ #category : 'accessing - markers' }
MiSourceTextSpecRenderer >> tagMarkers: aTag [

	^{TextColor color: aTag color}
]
