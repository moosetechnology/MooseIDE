"
I am the superclass of Moose Import commands.

Simple use: 
`MPImportSTCommand new execute`.

Link to a context (for example a spec presenter):
`(MPImportSTCommand forSpecContext: yourPresenter) execute`.
You can also use class side method `#asCommandGroupForSpecContext:` to build a Spec command group with both MSE and St import commands.
Your presenter should implement `#updateForNewModel:` to define behavior when a new model is installed successfully
"
Class {
	#name : #MiImportCommand,
	#superclass : #MiCommand,
	#category : #'MooseIDE-Meta-Import'
}

{ #category : #converting }
MiImportCommand class >> addToSpCommandGroup: aSpCommandGroup forSpecContext: aPresenter [

	{ 
		MiImportFromFileCommand.
		MiImportFromSTCommand } do: [ :cmd | 
		aSpCommandGroup register: ((cmd forSpecContext: aPresenter)
				 iconName: cmd defaultIconName;
				 yourself) ].
	^ aSpCommandGroup
]

{ #category : #converting }
MiImportCommand class >> asCommandGroupForSpecContext: aPresenter [

	^ self
		  addToSpCommandGroup: CmCommandGroup forSpec
		  forSpecContext: aPresenter
]

{ #category : #accessing }
MiImportCommand class >> importForm [

	self subclassResponsibility
]

{ #category : #testing }
MiImportCommand class >> isAbstract [
	^ self = MiImportCommand
]

{ #category : #execution }
MiImportCommand >> execute [

	(self class importForm on: self context) openDialog
]
