Class {
	#name : #MiImportFileStructureCommand,
	#superclass : #MiImportCommand,
	#category : #'MooseIDE-Meta-Import'
}

{ #category : #executing }
MiImportFileStructureCommand >> execute [

	MooseModel new
		importFileStructure;
		ifNotEmpty: [ :model | 
			model install.
			self context updateForNewModel: model ]
]
