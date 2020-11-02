Extension { #name : #Class }

{ #category : #'*GToolkit-Coder-Extensions' }
Class >> gtExamplesMapFor: aView context: aPhlowContext [
	<gtView>
	<gtClassView>
	| aMethodsCoderUIModel aMethodsCoder |
	aMethodsCoderUIModel := self methodsCoderFromContext: aPhlowContext.
	aMethodsCoder := aMethodsCoderUIModel coder.
	aMethodsCoder exampler hasExamples
		ifFalse: [ ^ aView empty ].
	^ aView forward
		title: 'Examples map';
		priority: 11;
		object: [ | allExamples |
			allExamples := Array
				streamContents: [ :aStream | 
					aMethodsCoder exampler
						allExecutableExampleCodersDo: [ :aCoder :anExample | aStream nextPut: anExample ] ].
			GtExampleGroup withAll: allExamples ];
		view: #gtMapFor:;
		actionStencilDo: [ :anExplicitAction | 
			anExplicitAction
				priority: 80;
				stencil: [ self runAllExamplesButtonForMethodsCoder: aMethodsCoder ] ];
		updateWhen:
			GtCodersCoderAdded , GtCodersCoderRemoved , GtCodersCodersChanged
				, GtCoderSourceCodeChanged
			in: [ aMethodsCoder ];
		addAutoUpdate: GtPhlowUpdateViewOnAddedToScene
]
