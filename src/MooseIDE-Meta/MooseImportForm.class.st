Class {
	#name : #MooseImportForm,
	#superclass : #SpPresenter,
	#instVars : [
		'originBrowser'
	],
	#category : #'MooseIDE-Meta-Import'
}

{ #category : #initialization }
MooseImportForm class >> windowExtent [

	self subclassResponsibility
]

{ #category : #action }
MooseImportForm >> importModel: aDialog [

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

{ #category : #initialization }
MooseImportForm >> initializeDialogWindow: aDialog [

	aDialog initialExtent: self class windowExtent.
	aDialog addButton: 'Import' do: [ :dialog | 
		self importModel: dialog ].
	aDialog addButton: 'Cancel' do: [ :dialog | dialog close ]
]

{ #category : #action }
MooseImportForm >> privateImportModel [

	self subclassResponsibility
]

{ #category : #'accessing model' }
MooseImportForm >> setModelBeforeInitialization: aBrowserOrMoosePanel [

	originBrowser := aBrowserOrMoosePanel
]

{ #category : #action }
MooseImportForm >> updateBrowserWith: mooseModel [

	originBrowser ifNotNil: [ 
		originBrowser updateForNewModel: mooseModel ]
]
