Class {
	#name : #MiImportFromFileCommand,
	#superclass : #MiImportCommand,
	#category : #'MooseIDE-Meta-Import'
}

{ #category : #'accessing - defaults' }
MiImportFromFileCommand class >> defaultDescription [

	^ 'Import model from MSE or JSON file'
]

{ #category : #accessing }
MiImportFromFileCommand class >> defaultIcon [

	^ MooseIcons mooseImportFile
]

{ #category : #initialization }
MiImportFromFileCommand class >> defaultIconName [

	^ #mooseImportFile
]

{ #category : #'accessing - defaults' }
MiImportFromFileCommand class >> defaultName [

	^ 'Import from file'
]

{ #category : #accessing }
MiImportFromFileCommand class >> importForm [

	^ MiImportModelFromFileDialog
]
