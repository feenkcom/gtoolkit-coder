Extension { #name : 'DebugSession' }

{ #category : '*GToolkit-Coder' }
DebugSession >> gtCreateModelForContext: aContext [

	^ (GtDebugContext forContext: aContext) topContext: interruptedContext
]

{ #category : '*GToolkit-Coder' }
DebugSession >> gtRecompileMethodTo: text inContext: aContext notifying: aNotifyer [
	"The retrieved information has changed and its source must now be updated.
	 In this case, the retrieved information is the method of the given context."

	| newMethod recompilationContext canRewind |
	canRewind := (self isContextPostMortem: self interruptedContext) not.
	"Do not try to recompile a doIt method"
	aContext method isDoIt
		ifTrue: [ ^ false ].
	(recompilationContext := (self gtCreateModelForContext: aContext) locateClosureHomeWithContent: text) ifNil: [ ^ false ].
	newMethod := (self gtCreateModelForContext: recompilationContext) recompileCurrentMethodTo: text notifying: aNotifyer.
	newMethod ifNil: [ ^ false ].
	newMethod isQuick
		ifTrue: [ recompilationContext := self downInContext: recompilationContext.
			recompilationContext jump: recompilationContext previousPc - recompilationContext pc ].
	(self isContextPostMortem: self interruptedContext)
		ifFalse: [ self rewindContextToMethod: newMethod fromContext: recompilationContext ].

	"Use an alarm instead of triggering the notification directly, as the content of
	the editor can still be unaccepted. "
	self installAlarm: #contextChanged.
	^ true
]
