"
Use me to generate tags from a Browser used to query entities of a model.
I open a Tag Browser if none is opened, and open the generator form with every query item produced by the browser using me.

Browsers should implement canGenerate and generate to use the generation command.
"
Class {
	#name : #MiOpenTagGeneratorCommand,
	#superclass : #MiCommand,
	#category : #'MooseIDE-Core-Command'
}

{ #category : #default }
MiOpenTagGeneratorCommand class >> defaultName [

	^ 'Generate tags'
]

{ #category : #testing }
MiOpenTagGeneratorCommand >> canBeExecuted [
	^ self context canGenerate
]

{ #category : #executing }
MiOpenTagGeneratorCommand >> execute [

	| app tagBrowser |
	app := MiApplication current.
	tagBrowser := (app browsers anySatisfy: [ :browser | 
		               browser class = MiTagBrowser ])
		              ifTrue: [ 
			              (app browsers select:
				              [ :browser | browser class = MiTagBrowser ]) anyOne ]
		              ifFalse: [ MiTagBrowser open ].

	tagBrowser window window activate restore. "bring the window in focus and in the foreground"
	tagBrowser openTagGenerationFormFor: self context itemsForGeneration
]
