"
Importer for C++ .ref file (CSV format developped for Siemens)
"
Class {
	#name : #MiCppRefFileImporter,
	#superclass : #MiAbstractFileImporter,
	#category : #'MooseIDE-Meta-Import'
}

{ #category : #executing }
MiCppRefFileImporter class >> fileExtension [
	^'ref'
]

{ #category : #running }
MiCppRefFileImporter >> run [
	Smalltalk at: #FamixCppCSVImporter
		ifPresent: [ :cls | 
			cls 
				runOn: nil 
				withRefFile: inputFile
				withModel: model ].
		
]
