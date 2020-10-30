Extension { #name : #GtPackageCoder }

{ #category : #'*GToolkit-Coder-Extensions' }
GtPackageCoder >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Package';
		priority: 1;
		stencil: [ self ];
		actionButtonIcon: BrGlamorousVectorIcons inspect
			action: [ :aButton | aButton phlow spawnTool: (GtPackageCoderTool package: self package) ]
]
