Class {
	#name : #MiImportModel,
	#superclass : #MiPresenter,
	#instVars : [
		'mooseModelDropbox',
		'textInput',
		'selectFileButton',
		'validate'
	],
	#category : #'Midas-Meta-Presenter'
}

{ #category : #specs }
MiImportModel class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #mooseModelDropbox withConstraints: [ :constraints | constraints height: self toolbarHeight ];
		add:
			(SpBoxLayout newHorizontal
				add: #textInput;
				add: #selectFileButton;
				yourself)
			withConstraints: [ :constraints | constraints height: self toolbarHeight ];
		yourself
]

{ #category : #specs }
MiImportModel class >> runMe [
	<script>
	^ self new
		openWithSpec
]

{ #category : #initialization }
MiImportModel >> initializeDialogWindow: aDialog [
	aDialog
		closeOnBackdropClick: false;
		addButton: 'Install'
			do: [ :presenter | 
			textInput text asFileReference readStreamDo: [ :aStream | (mooseModelDropbox selectedItem importFromMSEStream: aStream) install ].
			presenter close ];
		addButton: 'Cancel' do: [ :presenter | presenter close ]
]

{ #category : #initialization }
MiImportModel >> initializePresenters [
	super initializePresenters.
	mooseModelDropbox := self newDropList
		items: MooseModel withAllSubclasses;
		selectItem: MooseModel; 
		yourself.
	textInput := self newTextInput
		placeholder: 'Path to model';
		yourself.
	selectFileButton := self newButton
		label: 'Select file';
		action:
			[ | file |
			file := UIManager default chooseExistingFileReference: 'Import model from MSE file' extensions: #('mse') path: FileLocator home.
			file ifNotNil: [ textInput text: file asFileReference fullName ] ] yourself
]

{ #category : #initialization }
MiImportModel >> initializeWindow: aWindowPresenter [
	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: 'Import model';
		initialExtent:  300 @ (self class toolbarHeight * 5);
		centered
]
