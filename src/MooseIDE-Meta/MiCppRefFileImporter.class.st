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
	self flag: 'to be refactored as we do not have an input file but an input stream'.
	Smalltalk at: #FamixCppCSVImporter
		ifPresent: [ :cls | 
			cls 
				runOn: nil 
				withRefFile: inputStream
				withModel: model ].
		
]
