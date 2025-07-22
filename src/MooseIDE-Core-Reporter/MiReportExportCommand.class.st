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
	#name : 'MiReportExportCommand',
	#superclass : 'MiCommand',
	#category : 'MooseIDE-Core-Reporter',
	#package : 'MooseIDE-Core-Reporter'
}

{ #category : 'testing' }
MiReportExportCommand class >> asCommandGroupWith: aPresenter [

	| exportCommandGroup |
	exportCommandGroup := CmCommandGroup forSpec
		                      name: self defaultName;
		                      description: self defaultDescription;
		                      iconName: #smallExport.
	self allSubclassesDo: [ :cmd | 
		exportCommandGroup register: (cmd forSpecContext: aPresenter) ].
	^ exportCommandGroup
]

{ #category : 'testing' }
MiReportExportCommand class >> isAbstract [
	^ self = MiReportExportCommand
]

{ #category : 'executing' }
MiReportExportCommand >> execute [
	
	^self exportReport: self context 
]
