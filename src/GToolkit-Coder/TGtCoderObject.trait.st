"
I define common API for object holders.
See my users for more details: {{gtClass:TGtCoderObject | show= #gtUsersFor: | expanded=true}}. 
"
Trait {
	#name : #TGtCoderObject,
	#category : #'GToolkit-Coder-Object Holder'
}

{ #category : #'api - accessing' }
TGtCoderObject >> ifDefined: definedBlock ifNone: noneBlock [
	"Evaluate definedBlock if a self-object is defined, 
	passing the object as an argument: [ :aSelfObject | ].
	Evaluate noneBlock if the self-object is not defined."

	^ self explicitRequirement
]
