"
Abstract class for model import dialogs
"
Class {
	#name : #MiImportModelDialog,
	#superclass : #MiPresenter,
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
MiImportModelDialog >> importModel [

	| mooseModel |
	mooseModel := self privateImportModel.

	"Check if the model is empty. We are using size to optimize the code."
	(mooseModel size - (mooseModel allUsing: FamixTSourceLanguage) size)
		isZero ifTrue: [ 
		self error: 'Something is wrong, the imported model appears to be empty' ].

	^ mooseModel
]

{ #category : #action }
MiImportModelDialog >> importModelThenCloseDialogWindow: aDialog [

	| mooseModel |
	[self validateImportForm]  onErrorDo: [ :err | 
		UIManager default alert: 'Invalid input: ' , err messageText.
		^ self ].

	mooseModel := [ self importModel ] onErrorDo: [ :err | 
		              UIManager default alert:
			              'Import error: ' , err messageText.
		              nil ].

	mooseModel ifNotNil: [ 
		mooseModel install.
		aDialog close.
		self updateBrowserWith: mooseModel ]
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
MiImportModelDialog >> updateBrowserWith: mooseModel [

	originBrowser ifNotNil: [ 
		originBrowser updateForNewModel: mooseModel ]
]

{ #category : #action }
MiImportModelDialog >> validateImportForm [
	"checks that required fields are properly filled in"
	self subclassResponsibility 
]
