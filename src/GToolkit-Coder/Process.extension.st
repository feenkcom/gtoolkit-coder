Extension { #name : #Process }

{ #category : #'*GToolkit-Coder' }
Process >> gtDebugCoderFor: aView [
	<gtView>
	self isSuspended
		ifFalse: [ ^ self ].
	^ aView explicit
		title: 'Debugger';
		priority: 190;
		stencil: [ (GtProcessCoder forProcess: self) asElement ]
]
