Class {
	#name : #MiAutomaticModelsImportSettingBuilder,
	#superclass : #MiBooleanSettingBuilder,
	#category : #'MooseIDE-Meta-ModelsBrowser'
}

{ #category : #default }
MiAutomaticModelsImportSettingBuilder >> defaultAction [

	^ [ :boolean | self manager modelImportIsAutomatic: boolean ]
]

{ #category : #default }
MiAutomaticModelsImportSettingBuilder >> defaultCurrentValue [

	^ self manager modelImportIsAutomatic
]

{ #category : #default }
MiAutomaticModelsImportSettingBuilder >> defaultHelp [

	^ 'When drag & drop model from file should it be automatically imported if possible or should it just configure the import dialog'
]

{ #category : #default }
MiAutomaticModelsImportSettingBuilder >> defaultInitialValue [

	^ false
]

{ #category : #default }
MiAutomaticModelsImportSettingBuilder >> defaultLabel [

	^ 'Automatically import drag&drop files?'
]
