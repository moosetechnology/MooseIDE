Class {
	#name : #MiMicrodownPrettyPrinter,
	#superclass : #MicTextualMicrodownExporter,
	#category : #'MooseIDE-Export-Report'
}

{ #category : #visiting }
MiMicrodownPrettyPrinter >> visitText: aTextBlock [

	builder text: aTextBlock substring
]
