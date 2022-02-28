"
Abstract class for model import dialogs
"
Class {
	#name : #MiImportModelDialog,
	#superclass : #SpPresenter,
	#instVars : [
		'originBrowser'
	],
	#category : #'MooseIDE-Meta-Import'
}

{ #category : #opening }
MiImportModelDialog class >> open [
	^ self subclassResponsibility
]

{ #category : #initialization }
MiImportModelDialog class >> windowExtent [

	self subclassResponsibility
]

{ #category : #action }
MiImportModelDialog >> importModel: aDialog [

	| mooseModel |
	[ mooseModel := self privateImportModel ] onErrorDo: [ :err | 
		UIManager default alert: 'Import error: ' , err messageText.
		^ self ].

	"Check if the model is empty. We are using size to optimize the code."
	(mooseModel size - (mooseModel allUsing: FamixTSourceLanguage) size)
		isZero ifTrue: [ 
		UIManager default alert: 'You must select at least one package.'.
		^ self ].

	mooseModel install.
	self updateBrowserWith: mooseModel.

	"Close the dialog when the model was succefully installed"
	aDialog close
]

{ #category : #action }
MiImportModelDialog >> importModelThenCloseDialogWindow: aDialog [

	| mooseModel |
	[ mooseModel := self privateImportModel ] onErrorDo: [ :err | 
		UIManager default alert: 'Import error: ' , err messageText.
		^ self ].

	"Check if the model is empty. We are using size to optimize the code."
	(mooseModel size - (mooseModel allUsing: FamixTSourceLanguage) size)
		isZero ifTrue: [ 
		UIManager default alert: 'You must select at least one package.'.
		^ self ].

	"Set root folder if possible"
	[ self setRootFolderIfAvailableForModel: mooseModel ] onErrorDo: [ 
		:err | 
		UIManager default alert:
			'Error setting root folder: ' , err messageText.
		^ self ].

	mooseModel install.
	self updateBrowserWith: mooseModel.

	"Close the dialog when the model was succefully installed"
	aDialog close
]

{ #category : #initialization }
MiImportModelDialog >> initializeDialogWindow: aDialog [

	aDialog initialExtent: self class windowExtent.
	aDialog
		addButton: 'Import'
		do: [ :dialog | self importModelThenCloseDialogWindow: dialog ].
	aDialog addButton: 'Cancel' do: [ :dialog | dialog close ]
]

{ #category : #action }
MiImportModelDialog >> privateImportModel [

	self subclassResponsibility
]

{ #category : #'accessing - model' }
MiImportModelDialog >> setModelBeforeInitialization: aBrowserOrMoosePanel [

	originBrowser := aBrowserOrMoosePanel
]

{ #category : #action }
MiImportModelDialog >> setRootFolderIfAvailableForModel: aModel [

	"Override if this option is available"

	
]

{ #category : #action }
MiImportModelDialog >> updateBrowserWith: mooseModel [

	originBrowser ifNotNil: [ 
		originBrowser updateForNewModel: mooseModel ]
]
