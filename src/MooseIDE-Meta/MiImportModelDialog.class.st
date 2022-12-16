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
MiImportModelDialog >> handleImportError: err [

	| debug |
	debug := SpConfirmDialog new
		         title: 'Import error: ' , err messageText;
		         label: 'Do you want to open the debugger?';
		         acceptLabel: 'Yes';
		         cancelLabel: 'No';
		         openModal.
	debug ifTrue: [ err defaultAction ].
	^ nil
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

	| mooseModel aJob |
	[ self validateImportForm ] onErrorDo: [ :err | 
		UIManager default alert: 'Invalid input: ' , err messageText.
		^ self ].

	aJob := [ :job | 
	        job title: 'Importing model'.
	        mooseModel := [ self importModel ] onErrorDo: [ :err | 
		                      self handleImportError: err ].
	        job currentValue: 50.
	        mooseModel ifNotNil: [ 
		        mooseModel install.
		        aDialog close.
		        self updateBrowserWith: mooseModel ] ] asJob.

	[ aJob run ] forkAt: Processor userBackgroundPriority
]

{ #category : #initialization }
MiImportModelDialog >> initializeDialogWindow: aDialog [

	| button |
	button := nil. 
	aDialog initialExtent: self class windowExtent.
	button := aDialog
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

	originBrowser
	ifNotNil: [ originBrowser updateForNewModel: mooseModel ]
	ifNil: [ (MiApplication current allBrowsers: MiModelRootBrowser)
		do: [ :browser | browser updateList ] ]
]

{ #category : #action }
MiImportModelDialog >> validateImportForm [
	"checks that required fields are properly filled in"
	self subclassResponsibility 
]
