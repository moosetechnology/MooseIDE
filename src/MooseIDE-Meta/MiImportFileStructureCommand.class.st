Class {
	#name : #MiImportFileStructureCommand,
	#superclass : #MiImportCommand,
	#category : #'MooseIDE-Meta-Import'
}

{ #category : #default }
MiImportFileStructureCommand class >> defaultIcon [

	^ nil
]

{ #category : #default }
MiImportFileStructureCommand class >> defaultName [

	^ 'Import file model from file system'
]

{ #category : #executing }
MiImportFileStructureCommand >> execute [

	MooseModel new
		importFileStructure;
		ifNotEmpty: [ :model | 
			model install.
			self context updateForNewModel: model ]
]
