Extension { #name : #GtSourceCoderRequester }

{ #category : #'*GToolkit-Coder-UI' }
GtSourceCoderRequester >> notifyShowDebuggerRequest: aDebugSession dueTo: anException sourceString: aSourceString sourceInterval: aSourceInterval evaluationInfo: anEvaluationInfo [
	"Return true if announcement was handled (and debugger displayed in some way).
	Return false otherwise."

	^ self coder
		notifyShowDebuggerRequest: aDebugSession
		dueTo: anException
		sourceString: aSourceString
		sourceInterval: aSourceInterval
		evaluationInfo: anEvaluationInfo
]
