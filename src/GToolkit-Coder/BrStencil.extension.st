Extension { #name : #BrStencil }

{ #category : #'*GToolkit-Coder' }
BrStencil class >> gtInspectActionFor: anAction [
	<gtClassAction>
	self isAbstract ifTrue: [ ^ anAction noAction ].
	^ anAction button
		icon: BrGlamorousVectorIcons playinspect;
		tooltip: 'Inspect Stencil';
		priority: 10;
		action: [ :aButton | aButton phlow spawnObject: self new ]
]
