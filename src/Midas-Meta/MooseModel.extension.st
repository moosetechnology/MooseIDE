Extension { #name : #MooseModel }

{ #category : #'*Midas-Meta' }
MooseModel >> importFromMSE [
	| file |
	file := UIManager default chooseExistingFileReference: 'Import model from MSE file' extensions: #('mse') path: FileLocator home.
	file
		ifNotNil: [
			| stream | 
			stream := file readStream.
			self importFromMSEStream: stream.
			self name: (file basenameWithoutExtension).
			stream close ]
]
