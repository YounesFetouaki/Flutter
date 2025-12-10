const PDFDocument = require('pdfkit');
const fs = require('fs');

const doc = new PDFDocument();
doc.pipe(fs.createWriteStream('Rapport_Global_Ateliers.pdf'));

// Title Page
doc.fontSize(25).text('Rapport Global: Ateliers Flutter', { align: 'center' });
doc.moveDown();
doc.fontSize(16).text('Documentation complète des Ateliers 1 à 4.2', { align: 'center' });
doc.moveDown(2);

// Function to add section
function addSection(title, description, images) {
    doc.addPage();
    doc.fontSize(20).text(title, { underline: true });
    doc.moveDown();
    doc.fontSize(12).text(description);
    doc.moveDown();

    images.forEach(img => {
        if (fs.existsSync(img.path)) {
            doc.text(img.label, { align: 'center', bold: true });
            doc.image(img.path, { fit: [400, 300], align: 'center' });
            doc.moveDown();
        } else {
            doc.fillColor('red').text(`[Image manquante: ${img.path}]`, { align: 'center' });
            doc.fillColor('black');
            doc.moveDown();
        }
    });
}

// Atelier 1
addSection('Atelier 1: Interface de base',
    'Création des interfaces pour la liste des produits et l\'ajout de produits.', [
    { label: 'Accueil', path: 'global_docs/atelier1_home.png' },
    { label: 'Ajout Produit', path: 'global_docs/atelier1_add.png' }
]);

// Atelier 2
addSection('Atelier 2: Validation & UI',
    'Amélioration de l\'UX avec validation de formulaire et prévisualisation d\'image.', [
    { label: 'Accueil', path: 'global_docs/atelier2_home.png' },
    { label: 'Ajout (Validation)', path: 'global_docs/atelier2_add.png' }
]);

// Atelier 3
addSection('Atelier 3: Navigation',
    'Implémentation du Drawer et de la navigation vers les détails.', [
    { label: 'Accueil', path: 'global_docs/atelier3_home.png' },
    { label: 'Drawer', path: 'global_docs/atelier3_drawer.png' },
    { label: 'Détails', path: 'global_docs/atelier3_detail.png' }
]);

// Atelier 4.1
addSection('Atelier 4.1: SQLite',
    'Persistance locale des données avec SQLite.', [
    { label: 'Accueil (SQLite)', path: 'global_docs/atelier4_1_home.png' },
    { label: 'Ajout (SQLite)', path: 'global_docs/atelier4_1_add.png' }
]);

// Atelier 4.2 (Main)
addSection('Atelier 4.2: Firebase',
    'Synchronisation cloud en temps réel avec Firebase Firestore (Main Branch).', [
    { label: 'Accueil (Firebase)', path: 'global_docs/main_home.png' },
    { label: 'Ajout (Firebase)', path: 'global_docs/main_add.png' }
]);

doc.end();
console.log('Rapport Global généré avec succès.');
