"
Dialog used to import MSE models
"
Class {
	#name : #MiModelImporterFromMSE,
	#superclass : #MiPresenter,
	#instVars : [
		'mooseModelDropbox',
		'textInput',
		'selectFileButton',
		'validate',
		'modelRootBrowser'
	],
	#category : #'Midas-Meta-Presenter'
}

{ #category : #specs }
MiModelImporterFromMSE class >> defaultSpec [
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
MiModelImporterFromMSE class >> runMe [
	<script>
	^ self new
		openWithSpec
]

{ #category : #specs }
MiModelImporterFromMSE class >> title [
	^ 'Import model from MSE file'
]

{ #category : #initialization }
MiModelImporterFromMSE >> initializeDialogWindow: aDialog [
	aDialog
		closeOnBackdropClick: false;
		addButton: 'Install'
			do: [ :presenter | 
			| model |
			textInput text asFileReference
				readStreamDo: [ :aStream | 
					model := (mooseModelDropbox selectedItem importFromMSEStream: aStream)
						install ].
			modelRootBrowser updateWith: model.
			presenter close ];
		addButton: 'Cancel' do: [ :presenter | presenter close ]
]

{ #category : #initialization }
MiModelImporterFromMSE >> initializePresenters [
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
			file := UIManager default
				chooseExistingFileReference: 'Import model from MSE file'
				extensions: #('mse')
				path: FileLocator home.
			file ifNotNil: [ textInput text: file asFileReference fullName ] ]
				yourself
]

{ #category : #initialization }
MiModelImporterFromMSE >> initializeWindow: aWindowPresenter [
	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		initialExtent: 300 @ (self class toolbarHeight * 5);
		centered
]

{ #category : #'accessing model' }
MiModelImporterFromMSE >> setModelBeforeInitialization: aModelRootBrowser [
	modelRootBrowser := aModelRootBrowser
]
