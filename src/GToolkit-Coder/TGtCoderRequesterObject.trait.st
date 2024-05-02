Trait {
	#name : #TGtCoderRequesterObject,
	#category : #'GToolkit-Coder-Coders - Evaluation'
}

{ #category : #converting }
TGtCoderRequesterObject >> asCoderRequesterObject [
	^ self
]

{ #category : #'api - notifying' }
TGtCoderRequesterObject >> notifyShowDebuggerRequest: aDebugSession dueTo: anException sourceString: aSourceString sourceInterval: aSourceInterval [
	"Return true if announcement was handled (and debugger displayed in some way).
	Return false otherwise."

	^ false
]

{ #category : #accessing }
TGtCoderRequesterObject >> selfObject [
	"Return an object that is represented by `self` (or `super`) key"

	^ nil
]
