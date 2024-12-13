Extension { #name : #GtSourceCoder }

{ #category : #'*GToolkit-Coder-UI' }
GtSourceCoder >> notifyShowDebuggerRequest: aDebugSession dueTo: anException sourceString: aSourceString sourceInterval: aSourceInterval evaluationInfo: anEvaluationInfo [
	"Return true if announcement was handled (and debugger displayed in some way).
	Return false otherwise."

	<return: #Boolean>
	| anAnnouncement aSharedDebugSession |
	aSharedDebugSession := GtSharedDebugSession new
			session: aDebugSession.
	anAnnouncement := GtCoderShowDebuggerRequest new
			coder: self;
			debugSession: aDebugSession;
			sharedDebugSession: aSharedDebugSession;
			exception: anException;
			sourceString: aSourceString;
			sourceInterval: aSourceInterval;
			evaluationInfo: anEvaluationInfo.
	self announce: anAnnouncement.

	^ anAnnouncement isDelivered
]
