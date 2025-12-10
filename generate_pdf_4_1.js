const PDFDocument = require('pdfkit');
const fs = require('fs');

// Create a document
const doc = new PDFDocument();

// Pipe its output somewhere, like to a file or HTTP response
doc.pipe(fs.createWriteStream('rapport_atelier_4_1.pdf'));

// Header
doc
    .fontSize(25)
    .text('Rapport Atelier 4.1: SQLite', { align: 'center' });

doc.moveDown();

// Description
doc
    .fontSize(14)
    .text('Ce rapport documente l\'implémentation de la persistance des données avec SQLite dans l\'application Flutter.', { align: 'left' });

doc.moveDown();

doc
    .fontSize(12)
    .text('Fonctionnalités principales:', { underline: true });
doc
    .text('- Persistance locale des données produits.');
doc
    .text('- Utilisation du plugin sqflite.');
doc
    .text('- Pattern Singleton pour le DatabaseHelper.');
doc
    .text('- CRUD complet (Create, Read, Delete).');

doc.moveDown();

// Screenshots
doc.addPage();
doc
    .fontSize(18)
    .text('Screenshots', { align: 'center' });

doc.moveDown();

doc
    .fontSize(14)
    .text('Page d\'accueil (Liste des produits):', { align: 'left' });

doc.moveDown();

if (fs.existsSync('screenshots/atelier4_1_home.png')) {
    doc.image('screenshots/atelier4_1_home.png', {
        fit: [500, 400],
        align: 'center',
        valign: 'center'
    });
} else {
    doc.text('(Screenshot manquant)');
}

doc.addPage();

doc
    .fontSize(14)
    .text('Page d\'ajout de produit:', { align: 'left' });

doc.moveDown();

if (fs.existsSync('screenshots/atelier4_1_add.png')) {
    doc.image('screenshots/atelier4_1_add.png', {
        fit: [500, 400],
        align: 'center',
        valign: 'center'
    });
} else {
    doc.text('(Screenshot manquant)');
}

// Finalize PDF file
doc.end();
console.log('PDF generated successfully for Atelier 4.1');
