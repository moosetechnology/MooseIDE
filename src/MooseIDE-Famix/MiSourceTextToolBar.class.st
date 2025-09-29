"
A spec presenter for the toolbar of external editors

It looks for availableMiSourceTextExternalEditors, offer the choice to the user and can send the code of the displayed entity (in the browser) to this external editor, either on demand or automatically
"
Class {
	#name : #MiSourceTextToolBar,
	#superclass : #SpPresenter,
	#instVars : [
		'btnSend',
		'lstExternalEditors',
		'sourceTextBrowser',
		'externalEditor',
		'chkAutoTransmit',
		'autoTransmit'
	],
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #accessing }
MiSourceTextToolBar >> autoTransmit [
	^autoTransmit
]

{ #category : #accessing }
MiSourceTextToolBar >> autoTransmit: aBoolean [
	autoTransmit := aBoolean 
]

{ #category : #action }
MiSourceTextToolBar >> editExternally [
	sourceTextBrowser editExternally: self externalEditor
]

{ #category : #accessing }
MiSourceTextToolBar >> externalEditor [
	^externalEditor
]

{ #category : #accessing }
MiSourceTextToolBar >> externalEditor: aMiSourceTextExternalEditor [
	externalEditor := aMiSourceTextExternalEditor 
]

{ #category : #initialization }
MiSourceTextToolBar >> initialize [
	super initialize.
	self autoTransmit: false.
]

{ #category : #initialization }
MiSourceTextToolBar >> initializeLayout [

	self layout: (SpBoxLayout newLeftToRight
		spacing: 5 ;
		add: btnSend ;
		add: lstExternalEditors  ;
		add: chkAutoTransmit ;
		yourself)
]

{ #category : #initialization }
MiSourceTextToolBar >> initializePresenters [

	btnSend := self newButton 
		label: 'External Editor' ;
		icon: (self iconNamed: #smallDoIt) ;
		action: [ self editExternally ].

	lstExternalEditors := self newDropList
		items: MiSourceTextExternalEditor allExternalEditors;
		  display: [ :each | each editorName ];
		  whenSelectedItemChangedDo: [ :selectedItem | 
			  self externalEditor: selectedItem ];
		  yourself.

	self externalEditor: (lstExternalEditors items anyOne).

	chkAutoTransmit := self newCheckBox 
		label: 'Automatic send' ;
		whenActivatedDo: [ self autoTransmit: true ] ;
		whenDeactivatedDo: [ self autoTransmit: false] ;
		yourself.

	self initializeLayout
]

{ #category : #action }
MiSourceTextToolBar >> newEntity [
	self autoTransmit ifTrue: [ self editExternally ]
]

{ #category : #initialization }
MiSourceTextToolBar >> setModelBeforeInitialization: aSourceTextBrowser [
	sourceTextBrowser := aSourceTextBrowser 
]
