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

	<script>
	^ self new
		  openDialog;
		  yourself
]

{ #category : #accessing }
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
MiImportModelDialog >> importModelStep1Import [

	^ [ self importModel ] onErrorDo: [ :err |
		    (MorphicUIManager new
        confirm: ('Import error: ' , err messageText)
        trueChoice: 'Ignore'
        falseChoice: nil
        cancelChoice: 'Debug'
        default: false)
    ifNil: [ err pass ]
	 ifNotNil: [  ].
	]
]

{ #category : #action }
MiImportModelDialog >> importModelStep2Install: mooseModel [

	mooseModel ifNotNil: [
		mooseModel installWithCache: self shouldCreateCache.
		self withWindowDo: [ :window | window close ].
		self updateBrowserWith: mooseModel
	]
]

{ #category : #action }
MiImportModelDialog >> importModelThenCloseDialogWindow [

	| mooseModel aJob |
	[ self validateImportForm ] onErrorDo: [ :err |
		UIManager default alert: 'Invalid input: ' , err messageText.
		^ self ].

		aJob := [ :job |
		        job title: 'Importing model'.
		        mooseModel := self importModelStep1Import.
		        job currentValue: 50.
		        self importModelStep2Install: mooseModel ] asJob.

		[ aJob run ] forkAt: Processor userBackgroundPriority.
		self withWindowDo: [ :window | window close ].
	

]

{ #category : #initialization }
MiImportModelDialog >> initializeDialogWindow: aDialog [

	| button |
	button := nil.
	aDialog initialExtent: self class windowExtent.
	button := aDialog
		          addButton: 'Import'
		          do: [ self importModelThenCloseDialogWindow ].
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

{ #category : #testing }
MiImportModelDialog >> shouldCreateCache [

	^ originBrowser specModel shouldCreateCache 
]

{ #category : #action }
MiImportModelDialog >> updateBrowserWith: mooseModel [

	originBrowser
		ifNotNil: [ originBrowser updateForNewModel: mooseModel ]
		ifNil: [ MiApplication current currentModelsBrowser updateList ]
]

{ #category : #action }
MiImportModelDialog >> validateImportForm [
	"checks that required fields are properly filled in"
	self subclassResponsibility 
]

{ #category : #accessing }
MiImportModelDialog >> windowTitle [ 

	^ self class title 
	
]
